# 📌 Detecção de Operações Matemáticas com Arduino Nano 33 BLE Sense ![Arduino](https://img.shields.io/badge/-Arduino-00979D?style=for-the-badge&logo=Arduino&logoColor=white) ![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)

## 📖 Visão Geral
Este projeto tem como objetivo criar um modelo de detecção de objetos para rodar no **Arduino Nano 33 BLE Sense**, utilizando **Edge Impulse** para reconhecer números em operações matemáticas simples (+ ou -). Após a detecção, a equação é processada em um script em **python** que é enviados para a **nuvem** por meio de um módulo **Wi-Fi ESP8266**. Um aplicativo móvel em **Flutter** recebe e exibe o resultado final da equação, além de enviar comandos para iniciar a captura da imagem.

## ⚙️ Como Funciona?
1. O aplicativo Flutter envia um comando para iniciar a captura da imagem.
2. O Arduino Nano 33 BLE Sense captura a imagem usando a câmera **OV767X**.
3. O modelo de **Machine Learning** (Edge Impulse) processa a imagem e extrai os números e operadores matemáticos.
4. A informação processada é enviada para o **módulo Wi-Fi ESP8266**.
5. O módulo Wi-Fi ESP8266 transmite os dados para a **nuvem**.
6. O aplicativo móvel recebe a equação, realiza o cálculo e exibe o resultado para o usuário.

<div align="center" style="display: flex; gap: 50px; justify-content: center;"> 
    <img src="https://github.com/user-attachments/assets/bc9384b4-c824-466b-afb7-a47496504779" width="250">
    <img src="https://github.com/user-attachments/assets/a1c4ab20-a80d-4ee3-84b3-23e399635ea3" width="250">
    <img src="https://github.com/user-attachments/assets/6931ee5b-3f43-4be7-a71f-0c53afcfad01" width="250">
</div>

## 🧠 Modelo de Machine Learning

O modelo de Machine Learning foi treinado utilizando o Edge Impulse com amostras coletadas manualmente. Para isso, foram capturadas imagens de números e operadores matemáticos escritos à mão, criando um conjunto de dados diversificado. Durante o treinamento. O modelo final foi exportado no formato compatível com o Arduino Nano 33 BLE Sense, garantindo uma execução eficiente no dispositivo embarcado.

<div align="center" style="display: flex; gap: 50px; justify-content: center;">
   <img src="https://github.com/user-attachments/assets/4f859089-a1f5-4bb0-84fd-7f1c22ec671b" width="250">
</div>

## 🔧 Tecnologias Utilizadas
- **Hardware:** Arduino Nano 33 BLE Sense, Câmera OV767X, Módulo Wi-Fi ESP8266
- **Machine Learning:** Edge Impulse
- **Comunicação:** Wi-Fi/Serial para envio dos dados à nuvem
- **Backend:** Script em Python para comunicação entre o Arduino e o módulo Wi-Fi via porta serial
- **Aplicativo Móvel:** Desenvolvido em Flutter

## 📂 Estrutura do Projeto
```
📁 IoT-deteccao-matematica
├── 📂 firmware-modulo-wifi/      # Código do Módulo Wifi para comunicação com firebase
├── 📂 edge-impulse/              # Treinamento e exportação do modelo de IA
├── 📂 script-python/             # Script de comunicação Serial (Arduino ↔ Wi-Fi)
├── 📂 flutter-app/               # Aplicativo móvel
└── 📜 README.md                  # Documentação do projeto
```

## 🚀 Como Executar o Projeto
### 1️⃣ Configuração do Arduino
1. Instale a biblioteca **Arduino_OV767X** no Arduino IDE.
2. Faça o upload do código para o **Arduino Nano 33 BLE Sense**.
3. Instalação do **Módulo Wi-Fi ESP8266** [Programando o esp8266 pela arduino ide](https://www.robocore.net/tutoriais/programando-o-esp8266-pela-arduino-ide)
4. Integração com **Firebase** [Conexão com Firebase](https://www.youtube.com/watch?v=_ADdFH2K7SI)

### 2️⃣ Executar o Script Python
1. Certifique-se de ter **Python 3+** instalado.
2. Instale as dependências necessárias com:
   ```sh
   pip install pyserial
   ```
3. Execute o script para iniciar a comunicação Serial:
   ```sh
   python script-python/main.py
   ```

### 3️⃣ Rodar o Aplicativo Flutter
1. Instale o **Flutter** e configure o ambiente.
2. No terminal, execute:
   ```sh
   flutter pub get
   flutter run
   ```

---

