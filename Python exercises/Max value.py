def evaluate_max(num1,num2):
    if num1 > num2:
        return num1

    else:
            return num2

# get the user input

num1 = float(input("enter the first number"))
num2 = float(input("enter the seconed number"))

#get the results
max_value = evaluate_max(num1,num2)
print("the bigger number is:", max_value)