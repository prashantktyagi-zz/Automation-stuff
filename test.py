import os
from bs4 import BeautifulSoup
import re
def get_filepaths(directory):
    
    file_paths = []  # List which will store all of the full filepaths.

    for root, directories, files in os.walk(directory):
        for filename in files:
            filepath = os.path.join(root,filename)
            #if (filename == "index.html" or filename == "leftNav.html"):
            #    continue
            if (os.path.splitext(filepath)[1] == ".html"):
                file_paths.append(filepath)  # Add it to the list.
            else:
                #do nothing
                pass
                
    return file_paths



# Run the above function and store its results in a variable.   
full_file_paths = get_filepaths("C:\\Users\\prashanr\\CCM\\CCM4")
#print (full_file_paths)
ccm1_file = open('ccm4.txt', 'w')
#ccm2file = open('ccm2.txt', 'w')
#ccm3file = open('ccm3.txt', 'w')
for file_name in (full_file_paths):
    print(file_name)
    soup = BeautifulSoup(open(file_name),  "html.parser")
    print(soup)
    if (soup.body is not None):
        projectname = soup.body.find(text='Name: ').next
        ccm1_file.write("Project: " + projectname +"\n")
    #print(soup.prettify())
        count = 0
        UserList = 0
        number = 3
        for data in (soup.findAll("table")):
        
            for element in (data.select("td")):
                if element.string is None:
                    break
                if (element.string == "User Name"):
                    UserList = UserList + 1             
                else:
                    pass
                count = count +1
                print(element.string)
                ccm1_file.write(element.string)
                ccm1_file.write(" |  ")
                if (count == number):
                    ccm1_file.write("\n")
                    count = 0
                if(UserList == 2):
                    number = 2
            
ccm1_file.close()    
    

