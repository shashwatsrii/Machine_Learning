def tower_of_hanoi(n, source, destination, auxiliary):
    if n > 0:
        tower_of_hanoi(n-1, source, auxiliary, destination)
        print(f"Move disk {n} from {source} to {destination}")
        tower_of_hanoi(n-1, auxiliary, destination, source)


'''
Example usage considering 
source -> a
destination -> c
auxiliary -> b
'''

n = 2  
tower_of_hanoi(n, 'A', 'C', 'B')