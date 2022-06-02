import pandas as pd
import os
import subprocess

# get the files list
def getProgramsList():
	listOfFiles=str(subprocess.check_output(['pacman','-Qe']).decode('utf-8')).split('\n')
	temp = []
	for line in listOfFiles:
		words = line.split(' ')
		if words[0] == '':
			continue
		temp.append(words[0])
	return temp
def getProgramDescription(name):
		descriptionRaw=str(subprocess.check_output(['pacman','-Qi',''+name]).decode('utf-8')).split('\n')
		for line in descriptionRaw:
			words = line.split(' ')
			if words[0] == 'Description':
				ans = words[6]
				for it in range(7,len(words)):
					ans+=" " + words[it]
				return ans
		return ""
def getProgramsDescriptions(programsList):
	ans = [] 
	for program in programsList:
		description = getProgramDescription(program)
		ans.append(description)
	return ans
# ====== main program ======

# load the csv
main_csv = "progs.csv"
main_csv_dt = pd.read_csv(main_csv)
# delete all columns except the ones that contain links from the internet
main_csv_dt = main_csv_dt[main_csv_dt['#TAG'] == 'G']
# get the internet lists and the internet lists descriptions, also the tag list for the internet links
internetReposList = main_csv_dt['NAME IN REPO (or git url)'].to_list()
internetReposListDescriptions = main_csv_dt['PURPOSE (should be a verb phrase to sound right while installing)'].to_list()
tagsList = main_csv_dt['#TAG'].to_list()

# get the programs list from the system internal programs
programsList = getProgramsList()
number_of_programs = len(programsList)
tempList = []
# append A's to the list of tags
for it in range(number_of_programs):
	tempList.append('A')
tagsList  = tempList + tagsList
# join all the resulting
programsDescriptionList = getProgramsDescriptions(programsList)
programsList = programsList + internetReposList
programsDescriptionList = programsDescriptionList + internetReposListDescriptions

# create the final dataframe to change the csv file
zipped = list(zip(tagsList, programsList, programsDescriptionList))
finalDataFrame = pd.DataFrame(zipped,columns=['#TAG','NAME IN REPO (or git url)' , 'PURPOSE (should be a verb phrase to sound right while installing)'])

# replace the file with the new content
finalDataFrame.to_csv('progs.csv', encoding='utf-8', index=False)
