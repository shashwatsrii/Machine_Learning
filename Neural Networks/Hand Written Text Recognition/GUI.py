from tkinter import *
import numpy as np
from PIL import Image, ImageTk
from tkinter import filedialog
from Prediction import predict

window = Tk()
window.title("Handwritten digit recognition")
l1 = Label()

def MyProject():
    global l1

    # Open file dialog to select an image file
    filepath = filedialog.askopenfilename(title="Select Image", filetypes=[("Image files", "*.jpg;*.jpeg;*.png")])
    if filepath:
        # Load the image using PIL
        img = Image.open(filepath)
        # Resize the image to (28 x 28) px
        img = img.resize((28, 28))
        # Convert the image to grayscale
        img = img.convert('L')
        # Extract pixel matrix and convert it to a vector of (1, 784)
        x = np.asarray(img)
        vec = x.reshape((1, 784))

        # Loading Thetas
        Theta1 = np.loadtxt('Theta1.txt')
        Theta2 = np.loadtxt('Theta2.txt')

        # Calling function for prediction
        pred = predict(Theta1, Theta2, vec / 255)

        # Displaying the result
        l1.config(text="Digit = " + str(pred[0]), font=('Algerian', 20))
        l1.place(x=230, y=420)

def clear_widget():
    global l1
    l1.destroy()

# Label
L1 = Label(window, text="Handwritten Digit Recognition", font=('Algerian', 25), fg="blue")
L1.place(x=35, y=10)

# Button to select an image file
b2 = Button(window, text="1. Clear Result", font=('Algerian', 15), bg="white", fg="red", command=clear_widget)
b2.place(x=120, y=370)

# Display the selected image
def display_image():
    filepath = filedialog.askopenfilename(title="Select Image", filetypes=[("Image files", "*.jpg;*.jpeg;*.png")])
    if filepath:
        img = Image.open(filepath)
        img = img.resize((350, 290))
        img = ImageTk.PhotoImage(img)
        image_label.config(image=img)
        image_label.image = img

image_label = Label(window, width=50, height=90, bg='black')
image_label.place(x=120, y=70)

select_image_button = Button(window, text="Select Image", font=('Algerian', 15), bg="orange", fg="black", command=MyProject)
select_image_button.place(x=120, y=370)
# predict_image_button = Button(window, text="Show Image", font=('Algerian', 15), bg="orange", fg="black", command=display_image)
# predict_image_button.place(x=120, y=470)

window.geometry("600x500")
window.mainloop()
