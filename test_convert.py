import numpy as np

def quaternion_to_rotation_matrix(q):
    y, x, z, w = q
    Nq = w*w + x*x + y*y + z*z
    s = 2.0/Nq if Nq != 0 else 0
    X = x*s; Y = y*s; Z = z*s
    wX = w*X; wY = w*Y; wZ = w*Z
    xX = x*X; xY = x*Y; xZ = x*Z
    yY = y*Y; yZ = y*Z; zZ = z*Z
    return np.array([
        [1.0-(yY+zZ), xY-wZ, xZ+wY],
        [xY+wZ, 1.0-(xX+zZ), yZ-wX],
        [xZ-wY, yZ+wX, 1.0-(xX+yY)]
    ])

def y_rotation_angle(q):
    R = quaternion_to_rotation_matrix(q)
    return np.arctan2(R[0, 2], R[2, 2])

# Example usage
# "rotation":{"y":0.002871630247682333,"x":-0.0010441078338772058,"z":0.9987537264823914,"w":-0.04981643706560135},
q = np.array([0.002871630247682333, -0.0010441078338772058, 0.9987537264823914, -0.04981643706560135])
angle_in_radians = y_rotation_angle(q)
angle_in_degrees = np.degrees(angle_in_radians)

print(f"Rotation angle around y-axis in radians: {angle_in_radians}")
print(f"Rotation angle around y-axis in degrees: {angle_in_degrees}")

