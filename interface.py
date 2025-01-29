import serial
import time
from tkinter import Tk, Label, Button, messagebox
from PIL import Image, ImageTk
import numpy as np
import struct

# Inicializando a comunicação serial com o Arduino
ser = serial.Serial('COM4', 9600, timeout=1)  # Ajuste a porta serial conforme necessário
time.sleep(2)  # Aguarda a conexão ser estabelecida

def capture_image():
    # Envia o comando "capture" para o Arduino
    ser.write(b'capture\r\n')

    time.sleep(3)  # Dá um pequeno tempo para o Arduino processar

    # Agora, vamos ler a imagem que o Arduino enviará
    image_data = []
    
    # Espera até 5 segundos para receber os dados da imagem
    start_time = time.time()
    while time.time() - start_time < 5:
        if ser.in_waiting > 0:
            data = ser.read(ser.in_waiting)  # Lê os dados disponíveis
            image_data.extend(data)

    # Exibir o número de bytes recebidos para debug
    print(f"Imagem recebida com {len(image_data)} bytes.")
    
    # Converte os dados binários para hexadecimal
    image_hex = [f"0x{byte:02X}" for byte in image_data]

    # Exibe os primeiros 50 bytes hexadecimais para depuração
    print("Dados da imagem em hexadecimal:", image_hex[:50])

    # Verifica se a quantidade de bytes é suficiente para uma imagem de 144x176 pixels RGB24
    num_pixels = 144 * 176  # Resolução QCIF
    if len(image_data) >= num_pixels * 2:  # Garantindo que há bytes suficientes para a imagem
        # Filtra os dados para garantir que estamos lendo apenas os bytes necessários
        image_data = image_data[:num_pixels * 2]  # Filtra os dados para o tamanho correto de imagem

        # Converte os dados para a imagem
        raw_bytes = np.array(image_data, dtype="i2")

        image = np.zeros((len(raw_bytes), 3), dtype=int)

        for i in range(len(raw_bytes)):
            # Ler o pixel de 16 bits
            pixel = struct.unpack('>h', raw_bytes[i:i+1].tobytes())[0]

            # Converter RGB565 para RGB 24-bit
            r = ((pixel >> 11) & 0x1f) << 3
            g = ((pixel >> 5) & 0x3f) << 2
            b = ((pixel >> 0) & 0x1f) << 3
            image[i] = [r, g, b]

        image = np.reshape(image, (144, 176, 3))  # Resolução QCIF

        # Exibe a imagem
        display_image(image)
    else:
        messagebox.showerror("Erro", "Dados da imagem não recebidos corretamente.")

def display_image(image):
    # Exibir a imagem usando Tkinter
    image = Image.fromarray(image)
    image = image.resize((image.width // 2, image.height // 2))  # Reduz o tamanho da imagem para exibição
    image_tk = ImageTk.PhotoImage(image)
    label.config(image=image_tk)
    label.image = image_tk

# Configuração da interface gráfica
root = Tk()
root.title("Visualizador de Imagem da Câmera OV7675")

label = Label(root)
label.pack()

capture_button = Button(root, text="Capturar Imagem", command=capture_image)
capture_button.pack()

root.mainloop()
