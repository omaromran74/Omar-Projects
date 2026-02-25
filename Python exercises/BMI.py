import math

weight = float(input(" enter weight : "))
height = float(input(" enter height : "))

# show the person's bmi
bmi = weight / (height ** 2)

if bmi < 18.5:
    status = "underweight"
elif bmi < 25:
    status = "normal weight"
elif bmi < 30:
    status = "overweight"
else:
    status = "obesity"

# show result
print("BMI:", bmi)
print("Category:", status)
