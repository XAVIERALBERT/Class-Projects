from CSE8AFinal import get_graduates_data

data = get_graduates_data('graduates.csv')

def get_graduates_for_major_per_year(major, demographic):
    dct = {}
    lst = []
    for elem in data:
        for x in elem:
            if major == elem["Education.Major"]:
                if demographic == x:
                    lst.append((elem["Year"], elem[demographic]))
        dct.update(lst)
    return dct
