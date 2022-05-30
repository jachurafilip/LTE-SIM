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


/*
 * LTE-Sim is the main program of the LTE-Sim simulator.
 * To run simulations you can
 * (i) select one of example scenarios developed in Scenario/ ("./LTE-Sim -h" for details)
 * (ii) create a new scenario and add its reference into the main program.
 *
 *  To create a new scenario, see documentation in DOC/ folder.
 *
 *  For any questions, please contact the author at
 *  g.piro@poliba.it
 */


#include "TEST/test.h"

#include "scenarios/MultiUeInfiniteBufferOnly.h"
#include "scenarios/MultiUeAllTrafficTypes.h"
#include "scenarios/MultiUeRtTrafficOnly.h"
#include "TEST/scalability-test-macro-with-femto.h"
#include "TEST/test-sinr-femto.h"
#include "TEST/test-throughput-macro-with-femto.h"
#include "TEST/test-sinr-urban.h"
#include "TEST/test-throughput-urban.h"
#include "TEST/test-throughput-building.h"
#include "TEST/test-uplink-fme.h"
#include "TEST/test-uplink-channel-quality.h"


#include "utility/help.h"
#include <iostream>
#include <queue>
#include <fstream>
#include <stdlib.h>
#include <cstring>

int main(int argc, char *argv[])
{

    if (argc > 1)
    {
        /* Help */
        if (!strcmp(argv[1], "-h") || !strcmp(argv[1], "-H") || !strcmp(argv[1],
                                                                        "--help") || !strcmp(argv[1], "--Help"))
        {
            Help();
            return 0;
        }
        if (strcmp(argv[1], "test-amc-mapping")==0)
        {
            int cells = atoi(argv[2]);
            double radius = atof(argv[3]);
            int speed = atoi(argv[4]);
            int bandwidth = atoi(argv[5]);
            int cluster = atoi(argv[6]);

            TestAmcMapping (cells, radius, speed, bandwidth, cluster);
        }
        if (strcmp(argv[1], "NonRtTraffic") == 0)
        {
            int scheduler = atoi(argv[2]);
            int nbUE = atoi(argv[3]);
            int speed = atoi(argv[4]);
            int simulationTime = atoi(argv[5]);
            int seed = atoi(argv[6]);
            int cellsize = atoi(argv[7]);
            MultiUeInfiniteBufferOnly(scheduler, nbUE, speed, simulationTime, seed, cellsize);
        }
        if (strcmp(argv[1], "RtTraffic") == 0)
        {
            int scheduler = atoi(argv[2]);
            int nbUE = atoi(argv[3]);
            int speed = atoi(argv[4]);
            double maxDelay = atof(argv[5]);
            int simulationTime = atoi(argv[6]);
            int seed = atoi(argv[7]);
            int cellsize = atoi(argv[8]);
            MultiUeRtTraffic(scheduler, nbUE, speed, maxDelay, simulationTime, seed, cellsize);
        }

        if (strcmp(argv[1], "AllTraffic") == 0)
        {
            int scheduler = atoi(argv[2]);
            int nbUE = atoi(argv[3]);
            int speed = atoi(argv[4]);
            double maxDelay = atof(argv[5]);
            int simulationTime = atoi(argv[6]);
            int seed = atoi(argv[7]);
            int cellsize = atoi(argv[8]);
            MultiUeAllTrafficTypes(scheduler, nbUE, speed, maxDelay, simulationTime, seed, cellsize);
        }
    }
}
