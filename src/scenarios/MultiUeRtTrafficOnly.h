/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/*
 * Copyright (c) 2010,2011,2012,2013 TELEMATICS LAB, Politecnico di Bari
 *
 * This file is part of LTE-Sim
 *
 * LTE-Sim is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation;
 *
 * LTE-Sim is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with LTE-Sim; if not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Giuseppe Piro <g.piro@poliba.it>
 */

#include "../channel/LteChannel.h"
#include "../core/spectrum/bandwidth-manager.h"
#include "../networkTopology/Cell.h"
#include "../core/eventScheduler/simulator.h"
#include "../flows/application/InfiniteBuffer.h"
#include "../flows/QoS/QoSParameters.h"
#include "../componentManagers/FrameManager.h"
#include "../componentManagers/FlowsManager.h"
#include "../device/ENodeB.h"
#include "../channel/propagation-model/macrocell-rural-area-channel-realization.h"


static void MultiUeRtTraffic (int scheduler, int nbUE, int speed, double maxDelay, int simulationTime, int seed, int cellSize)
{
    int testSeed = GetCommonSeed (seed);
    srand (testSeed);

    // CREATE COMPONENT MANAGERS
    Simulator *simulator = Simulator::Init();
    FrameManager *frameManager = FrameManager::Init();
    NetworkManager* networkManager = NetworkManager::Init();

    //Create CHANNELS
    LteChannel *dlCh = new LteChannel ();
    LteChannel *ulCh = new LteChannel ();

    //Application containters
    VoIP voipApplication[nbUE];
    TraceBased videoApplication[nbUE];

    int voipApplicationCounter = 0;
    int videoApplicationCounter = 0;
    int applicationID = 0;
    int destinationPort = 101;

    // CREATE SPECTRUM
    BandwidthManager* spectrum = new BandwidthManager (20, 20, 0, 0);
    frameManager->SetFrameStructure(FrameManager::FRAME_STRUCTURE_FDD);

    // CREATE CELL
    int radius = cellSize; //km
    Cell *cell = new Cell (0, radius, 0.035, 0, 0);
    networkManager->GetCellContainer ()->push_back (cell);


    //Create ENodeB
    ENodeB* enb = new ENodeB (1, cell, 0, 0);
    enb->GetPhy ()->SetDlChannel (dlCh);
    enb->GetPhy ()->SetUlChannel (ulCh);
    enb->GetPhy ()->SetBandwidthManager (spectrum);
    ulCh->AddDevice (enb);
    ENodeB::DLSchedulerType schedulerType;
    switch(scheduler)
    {
        case 1:
            schedulerType = ENodeB::DLScheduler_TYPE_PROPORTIONAL_FAIR;
            break;
        case 2:
            schedulerType = ENodeB::DLScheduler_TYPE_FLS;
            break;
        case 3:
            schedulerType = ENodeB::DLScheduler_TYPE_MLWDF;
            break;
        default:
            schedulerType = ENodeB::DLScheduler_TYPE_PROPORTIONAL_FAIR;
            break;
    }
    enb->SetDLScheduler (schedulerType);
    networkManager->GetENodeBContainer ()->push_back (enb);


    //Create GW
    Gateway *gateway = new Gateway ();
    networkManager->GetGatewayContainer ()->push_back (gateway);


    //Create UE
    for(int idUE=2; idUE<2+nbUE; idUE++)
    {
      //ue's random position
      int maxXY = radius * 1000; // in metres
      double posX = (double)rand()/RAND_MAX; posX = 0.95 *
                                                    ((2*maxXY*posX) - maxXY);
      double posY = (double)rand()/RAND_MAX; posY = 0.95 *
                                                    ((2*maxXY*posY) - maxXY);
      double speedDirection = (double)(rand() %360) * ((2*3.14)/360);

      UserEquipment* ue = new UserEquipment (idUE,
                                             posX, posY, speed, speedDirection,
                                             cell,
                                             enb,
                                             false,
                                             speed == 0 ? Mobility::CONSTANT_POSITION : Mobility::RANDOM_WALK);

      std::cout << "Created UE - id " << idUE << " position " << posX << " " << posY << std::endl;

      ue->GetPhy ()->SetDlChannel (dlCh);
      ue->GetPhy ()->SetUlChannel (ulCh);

      FullbandCqiManager *cqiManager = new FullbandCqiManager ();
      cqiManager->SetCqiReportingMode (CqiManager::PERIODIC);
      cqiManager->SetReportingInterval (1);
      cqiManager->SetDevice (ue);
      ue->SetCqiManager (cqiManager);

      WidebandCqiEesmErrorModel *errorModel = new WidebandCqiEesmErrorModel ();
      ue->GetPhy ()->SetErrorModel (errorModel);

      networkManager->GetUserEquipmentContainer ()->push_back (ue);

      // register ue to the enb
      enb->RegisterUserEquipment (ue);
      // define the channel realization
      auto* c_dl = new MacroCellRuralAreaChannelRealization (enb, ue);
      enb->GetPhy ()->GetDlChannel ()->GetPropagationLossModel ()->AddChannelRealization (c_dl);
      auto* c_ul = new MacroCellRuralAreaChannelRealization (ue, enb);
      enb->GetPhy ()->GetUlChannel ()->GetPropagationLossModel ()->AddChannelRealization (c_ul);

      // CREATE DOWNLINK APPLICATIONS FOR THIS UE
      double startTime = 0.5;
      double flowDuration = simulationTime;
      double durationTime = startTime + flowDuration;

      // create application
      voipApplication[voipApplicationCounter].SetSource (gateway);
      voipApplication[voipApplicationCounter].SetDestination (ue);
      voipApplication[voipApplicationCounter].SetApplicationID (applicationID);
      voipApplication[voipApplicationCounter].SetStartTime(startTime);
      voipApplication[voipApplicationCounter].SetStopTime(startTime + durationTime);

      // create qos parameters
      if (schedulerType == ENodeB::DLScheduler_TYPE_FLS)
      {
          QoSForFLS *qos = new QoSForFLS ();
          qos->SetMaxDelay (maxDelay);
          voipApplication[voipApplicationCounter].SetQoSParameters (qos);
      }
      else if (schedulerType == ENodeB::DLScheduler_TYPE_MLWDF)
      {
          QoSForM_LWDF *qos = new QoSForM_LWDF ();
          qos->SetMaxDelay (maxDelay);
          voipApplication[voipApplicationCounter].SetQoSParameters (qos);
      }
      else
      {
          QoSParameters *qos = new QoSParameters ();
          qos->SetMaxDelay (maxDelay);
          voipApplication[voipApplicationCounter].SetQoSParameters (qos);
      }


      //create classifier parameters
      ClassifierParameters *cpVoip = new ClassifierParameters (gateway->GetIDNetworkNode(),
                                                               ue->GetIDNetworkNode(),
                                                               0,
                                                               destinationPort,
                                                               TransportProtocol::TRANSPORT_PROTOCOL_TYPE_UDP);
      voipApplication[voipApplicationCounter].SetClassifierParameters (cpVoip);

      std::cout << "CREATED VOIP APPLICATION, ID " << applicationID << std::endl;

      //update counter
      destinationPort++;
      applicationID++;
      voipApplicationCounter++;

      // create application
      videoApplication[videoApplicationCounter].SetSource (gateway);
      videoApplication[videoApplicationCounter].SetDestination (ue);
      videoApplication[videoApplicationCounter].SetApplicationID (applicationID);
      videoApplication[videoApplicationCounter].SetStartTime(startTime);
      videoApplication[videoApplicationCounter].SetStopTime(startTime + durationTime);

      string video_trace ("foreman_H264_");

      string _file (path + "src/flows/application/Trace/" + video_trace + "242k.dat");
      videoApplication[videoApplicationCounter].SetTraceFile(_file);
      std::cout << "		selected video @ 242k"<< std::endl;

      // create qos parameters
      if (schedulerType == ENodeB::DLScheduler_TYPE_FLS)
      {
          QoSForFLS *qos = new QoSForFLS ();
          qos->SetMaxDelay (maxDelay);
          videoApplication[videoApplicationCounter].SetQoSParameters (qos);
      }
      else if (schedulerType == ENodeB::DLScheduler_TYPE_MLWDF)
      {
          QoSForM_LWDF *qos = new QoSForM_LWDF ();
          qos->SetMaxDelay (maxDelay);
          videoApplication[videoApplicationCounter].SetQoSParameters (qos);
      }
      else
      {
          QoSParameters *qos = new QoSParameters ();
          qos->SetMaxDelay (maxDelay);
          videoApplication[videoApplicationCounter].SetQoSParameters (qos);
      }


      //create classifier parameters
      ClassifierParameters *cpVideo = new ClassifierParameters (gateway->GetIDNetworkNode(),
                                                                ue->GetIDNetworkNode(),
                                                                0,
                                                                destinationPort,
                                                                TransportProtocol::TRANSPORT_PROTOCOL_TYPE_UDP);
      videoApplication[videoApplicationCounter].SetClassifierParameters (cpVideo);

      std::cout << "CREATED VIDEO APPLICATION, ID " << applicationID << std::endl;

      //update counter
      destinationPort++;
      applicationID++;
      videoApplicationCounter++;



    }
    simulator->SetStop(simulationTime + 1);
    simulator->Run ();

}
