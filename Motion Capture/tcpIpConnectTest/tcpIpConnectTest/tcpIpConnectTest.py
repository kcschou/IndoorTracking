"""
    Minimal usage example
    Connects to QTM and streams 3D data forever
    (start QTM first, load file, Play->Play with Real-Time output)
"""

import asyncio
import qtm
import numpy



def on_packet(packet):
    """ Callback function that is called everytime a data packet arrives from QTM """
    print("Framenumber: {}".format(packet.framenumber))
    header, markers = packet.get_3d_markers()
    print("Component info: {}".format(header))

    header, analog = packet.get_analog()
    print("analog info: {}".format(header))

    #could maybe be used for measurement of angle
    x = markers[0].x - markers[1].x
    print(x)
    y = markers[0].y - markers[1].y
    print(y)
    #
    for marker in markers:
        print("\t", marker)
        startPointX = 0
        startPointY = 0
        dist = numpy.linalg.norm(startPointX-marker.x)
       
        #print("dist: ", dist)



async def setup():
    """ Main function """
    connection = await qtm.connect("10.80.11.203", 22223, 1.16)
    if connection is None:
        return
    
    await connection.stream_frames(components=["3d"], on_packet=on_packet)
    


if __name__ == "__main__":
    asyncio.ensure_future(setup())
    asyncio.get_event_loop().run_forever()

