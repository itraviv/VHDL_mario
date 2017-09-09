import sys

with open(sys.argv[1]) as f:
	content = f.readlines()
content = [x.strip() for x in content]

i = 0 
for x in content:
	x_R=x.strip(";").split(" : ")
	if len(x_R)>1:
		if i==0:
			sys.stdout.write( "(x\""+x_R[1]+"\", ")
		else:
			if i%25==0:
				sys.stdout.write( "x\""+x_R[1]+"\"),\n")
				i=0
				continue
			else:
				sys.stdout.write( "x\""+x_R[1]+"\", " )
		i+=1






