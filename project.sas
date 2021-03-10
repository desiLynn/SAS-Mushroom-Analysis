PROC IMPORT OUT = mushrooms
	DATAFILE = "\\net.ucf.edu\cst\userfolderslabs\de540422\My Documents\My SAS Files\9.4\Homework\mushrooms.csv" 
	DBMS = csv 
	replace;
RUN;

DATA mushrooms;
	set mushrooms;
	drop stalk_root;
RUN;

ods graphics on;
PROC FREQ data = mushrooms;
	tables (cap_shape--habitat)*class/ chisq plots=freqplot(type=dot);
RUN;
ods graphics off;

data mush_important;
	set mushrooms;
	keep class odor gill_color ring_type spore_print_color habitat;
RUN;

ods graphics on;
PROC FREQ data = mush_important;
	tables class*habitat/ chisq plots=freqplot(type=dot);
RUN;
ods graphics off;

PROC CATMOD data = mush_important order = data;
	population habitat;
	response /out=predict;
	model class = odor gill_color ring_type spore_print_color / pred=prob;
RUN;

proc print data=predict;run;

PROC GPLOT data = predict;
	plot _pred_*habitat=class;
	where _type_="PROB";
	symbol1 color=green width=5 value=diamond;
	symbol2 color=red width=5 value=x;
RUN;

PROC CATMOD data = mush_important order = data;
	response /out=predict;
	model class = odor / pred=prob;
RUN;

proc print data=predict;run;

PROC GPLOT data = predict;
	plot _pred_*odor=class;
	where _type_="PROB";
	symbol1 color=green width=5 value=diamond;
	symbol2 color=red width=5 value=x;
RUN;

PROC CATMOD data = mush_important order = data;
	response /out=predict;
	model class = gill_color / pred=prob;
RUN;

proc print data=predict;run;

PROC GPLOT data = predict;
	plot _pred_*gill_color=class;
	where _type_="PROB";
	symbol1 color=green width=5 value=diamond;
	symbol2 color=red width=5 value=x;
RUN;

ods graphics on;
PROC FREQ data = mush_important;
	tables habitat*(odor gill_color)*class/ chisq plots=freqplot(type=dot);
RUN;
ods graphics off;
