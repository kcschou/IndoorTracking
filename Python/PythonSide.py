# If you get a permision denide on ttyUSB0 it's because the permisions didn't stick, so run: sudo chmod a+rw /dev/ttyUSB0 

from rplidar import RPLidar
lidar = RPLidar('/dev/ttyUSB0') # For Linux
#lidar = RPLidar('COM8') # For Windows
import sys
import time

output = str
newScan = False

import socket
HOST = 'localhost'
PORT = 10002

numberOfScans = 0

#start_time = time.time()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        conn, addr = s.accept()
        with conn:
                data = int.from_bytes(conn.recv(1024), byteorder=sys.byteorder)
                print("Data:",data)
                while data == 1:
                        print("entered the while loop")
                        for i in lidar.iter_measurments(max_buf_meas=10000):
                                if i.__getitem__(3) != 0:
                                        if i.__getitem__(0) == 1:
                                                numberOfScans+=1
                                                print("sent:"+str(numberOfScans)+"scans, at a process time of:"+str(time.process_time()))
                                        
                                        output = str(i.__getitem__(3)) + "," + str(i.__getitem__(2)) + "," + str(i.__getitem__(0))
                                        
                                        conn.send(str.encode(output))

lidar.stop()
lidar.stop_motor()
lidar.disconnect()