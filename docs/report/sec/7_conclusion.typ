== Lessons Learned

This project provided valuable insight into the challenges of integrating
hardware and software systems in a real-time environment. One of the key lessons
learned was the importance of working within hardware constraints. The lack of
position feedback from the DC motors required alternative solutions, such as the
implementation of a manual homing.

Another important takeaway was the role of system architecture in managing
complexity. Separating the system into a Computer Layer and a Microcontroller
Layer allowed for clearer responsibilities, improved scalability, and easier
debugging. This modular approach proved essential when integrating multiple
subsystems, including serial communication, motor control, and data
visualization.

== Future Improvements

Several areas for improvement have been identified for future iterations of this
system. The most significant enhancement would be the integration of position
feedback, either through the use of servo motors or the addition of encoders to
the existing DC motors. This would enable true closed-loop control and
significantly improve the accuracy of the analog gauges.

From a system design perspective, the current setup could be optimized for
usability and portability. Automating the initialization process, including
serial port configuration and synchronization between components, would reduce
setup complexity and make the system more user-friendly. The addition of
wireless communication, such as Bluetooth, could further decouple the system
from the computer and improve portability.

On the software side, implementing formal testing frameworks would improve
reliability and maintainability. Expanding the dashboard functionality,
including additional visualization features and user interaction, would also
enhance the overall user experience. Finally, refining the mechanical design of
the gauge system to include an actual scale from $0 degree - 360 degree$ and
incorporating it into a 3D printed enclosure would refine the project further.

== Final Thoughts

Overall, this project successfully demonstrates the feasibility of a
hardware-software integrated flight instrumentation system. The combination of
motorized analog gauges, digital displays, and a real-time dashboard creates a
tangible and interactive representation of flight data. While the system has
limitations, particularly regarding accuracy and software deployability, it
achieves its core objectives.

Beyond the technical outcomes, this project provided valuable experience in
embedded systems development within an aerospace context, allowing me to
join mechanical engineering and computer science into a working
system.

#pagebreak()

