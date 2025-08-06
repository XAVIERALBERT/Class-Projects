from CSE8AFinal import get_graduates_data

data = get_graduates_data('graduates.csv')

def get_majors_under_threshold(year, demographic, threshold):
    result = []
    lst = []
    for elem in data:
        for x in elem:
            if year == elem['Year']:
                if elem["Demographics.Total"] == 0:
                    ratio = 0
                elif demographic == x:
                    ratio = elem[demographic]/elem["Demographics.Total"]
                    result.append((elem["Education.Major"],ratio))
    for i in result:
        if i[-1] <= threshold/100:
            lst.append(i[0])
                  
    return lst

    
