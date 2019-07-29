#!/usr/bin/python
"""Configuratin file for microscope.deviceserver.

Import device classes, then define entries in DEVICES as:
   devices(CLASS, HOST, PORT, other_args)
"""
# Function to create record for each device.
from microscope.devices import device
# Import device modules/classes here.
import microscope.testsuite.devices as testdevices

DEVICES = [
    device(testdevices.TestCamera, '127.0.0.1', 8000,),
    device(testdevices.TestLaser, '127.0.0.1', 8001),
]
