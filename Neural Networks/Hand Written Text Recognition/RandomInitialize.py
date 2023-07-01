import numpy as np
def initialize(a,b):
    epsilon = 0.15
    c = np.random.rand(a,b+1)*(2*epsilon)-epsilon
    # Randomly intialises values of thetas between -epsilon and +epsilon
    return c