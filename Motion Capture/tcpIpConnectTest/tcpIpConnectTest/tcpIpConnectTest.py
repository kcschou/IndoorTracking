"""
    Minimal usage example
    Connects to QTM and streams 3D data forever
    (start QTM first, load file, Play->Play with Real-Time output)
"""

import asyncio
import qtm
import numpy
import xml.etree.ElementTree as ET






def create_body_index(xml_string):
    """ Extract a name to index dictionary from 6dof settings xml """
    xml = ET.fromstring(xml_string)

    body_to_index = {}
    for index, body in enumerate(xml.findall("*/Label/Name")):
        body_to_index[body.text.strip()] = index
        print(body.text.strip())
    print(body_to_index)
    return body_to_index

async def main():
    
    """ Main function """
    connection = await qtm.connect("10.80.11.203", 22223, 1.16)
    if connection is None:
        return

    xml_string = await connection.get_parameters(parameters=["3d"])
    body_index = create_body_index(xml_string)
    
    wanted_body = "front"

    def on_packet(packet):
        info, bodies = packet.get_3d()
        """ Callback function that is called everytime a data packet arrives from QTM """
        #print("Framenumber: {}".format(packet.framenumber))
        header, markers = packet.get_3d_markers()
        #print("Component info: {}".format(header))

        #header, analog = packet.get_analog()
        #print("analog info: {}".format(header))

        #could maybe be used for measurement of angle
        #x = markers[0].x - markers[1].x
        #print(x)
        #y = markers[0].y - markers[1].y
        #print(y)
        #
        for marker in markers:
            #print("\t", marker)
            startPointX = 0
            startPointY = 0
            dist = numpy.linalg.norm(startPointX-marker.x)
       
            #print("dist: ", dist)
        if wanted_body is not None and wanted_body in body_index:
                # Extract one specific body
                wanted_index = body_index[wanted_body]
                print(wanted_index)
                position, rotation = bodies[wanted_index]
                print("{} - Pos: {} - Rot: {}".format(wanted_body, position, rotation))

    await connection.stream_frames(components=["3d"], on_packet=on_packet)
    
    

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())

