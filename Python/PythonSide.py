# If you get a permision denide on ttyUSB0 it's because the permisions didn't stick, so run: sudo chmod a+rw /dev/ttyUSB0 

from rplidar import RPLidar
lidar = RPLidar('/dev/ttyUSB0') # For Linux
#lidar = RPLidar('COM8') # For Windows

import socket
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('localhost', 5204))

import time

output = str

newScan = 0

for i in lidar.iter_scans(max_buf_meas=1000):
        # output = ""
        for j in range(len(i)):
            if i.__getitem__(j).__getitem__(2) != 0:
                output = str(i.__getitem__(j).__getitem__(2)) + "," + str(i.__getitem__(j).__getitem__(1)) + "," + str(newScan)
                newScan = 0
                if j % 20 == 0:
                    newScan = 1
                client_socket.send(str.encode(output))
                time.sleep(0.2)
        newScan = 1

# snippet from https://rplidar.readthedocs.io/en/latest/
        # Yields:  scan : list
        # List of the measurments. Each measurment is tuple with following format: (quality, angle, distance). For values description please refer to iter_measurments method’s documentation.

lidar.stop()
lidar.stop_motor()
lidar.disconnect()