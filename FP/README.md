# Face Detection 

PYNQ-Z2 is a development board based on the Xilinx Zynq-7000 SoC, characterized by its ability to integrate **Python with Zynq FPGA**. This feature provides a higher-level design capability for embedded system development, allowing designers to create overlays for implementing designs on the PL (Programmable Logic) side. Additionally, it includes a Jupyter Notebook interface, enabling designers to operate the hardware resources of the PYNQ-Z2 board through Python scripting, offering a convenient and powerful development environment.

In this project, our goal is to implement input data preprocessing and face detection on the PS side of the PYNQ-Z2. The recognized face data will be transmitted to the PL side via **AXI4-Stream** and **DMA**. Subsequently, image sharpening will be performed using the **SOBEL RTL CORE** and **Line Buffer**. Finally, the results will be sent back to the PS side. 

The performance of PL-accelerated computation will be compared to that of processing solely on the PS side to evaluate the acceleration factor achieved.

For detailed implementation steps, please refer to the [provided .ipynb file](https://github.com/minsheng0503/SOC_LAB/blob/main/FP/Face_Detection_Sharpen.ipynb).

![Block Diagram](https://github.com/minsheng0503/SOC_LAB/blob/main/FP/image/BlockDesign.png)