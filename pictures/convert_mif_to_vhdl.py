import sys

with open(sys.argv[1]) as f:
	content = f.readlines()
content = [x.strip() for x in content]

f_output = open(sys.argv[2],"w")

width = raw_input("enter image width: ")


i = 0 
for x in content:
	x_R=x.strip(";").split(" : ")
	if len(x_R)>1:
		if i==0:
			f_output.write( "(x\""+x_R[1]+"\", ")
		else:
			if i%(int(width) -1)==0:
				f_output.write( "x\""+x_R[1]+"\"),\n")
				i=0
				continue
			else:
				f_output.write( "x\""+x_R[1]+"\", " )
		i+=1






