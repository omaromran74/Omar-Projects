# get score
def average(scores):
    return sum(scores) / len(scores)

# get grades
def get_grade(score):
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"

# ask for five scores 
scores = []
for i in range(5):
    score = float(input("Enter score " + str(i + 1) + ": "))
    scores.append(score)

# get the avg
avg = average(scores)

# show the avg and grades
for i in range(5):
    print("Score", i + 1, ":", scores[i], "Grade:", get_grade(scores[i]))

print("Average Score:", avg, "Grade:", get_grade(avg))
