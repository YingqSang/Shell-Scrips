#! /bin/sh
mseed_folder=/run/media/sangyq/SeisData/JL_Data/originalData/201808/mseed_by_day
sac_folder=/run/media/sangyq/SeisData/JL_Data/originalData/201808/sacfile
mseed2sac_folder=/home/sangyq/Downloads/software/mseed2sac-master
stainfo=/run/media/sangyq/SeisData/JL_Data/originalData/JLstations.txt
for sta in `ls $mseed_folder | grep ^JL`
do
	lat=`cat $stainfo | grep ^$sta | awk -F, '{print $2}'`
	lon=`cat $stainfo | grep ^$sta | awk -F, '{print $3}'`
	elv=`cat $stainfo | grep ^$sta | awk -F, '{print $4}'`
	output_sacfile_folder=$sac_folder/$sta
	if [ ! -d "$output_sacfile_folder" ];then
		mkdir $output_sacfile_folder
	fi
	cp $mseed2sac_folder/mseed2sac $output_sacfile_folder
	cd $output_sacfile_folder

	# N component	
	for mseedfile in  `ls $mseed_folder/$sta | grep BH1`
	do
		./mseed2sac -k $lat/$lon -C 'BHN' $mseed_folder/$sta/$mseedfile
	done
	# E component	
	for mseedfile in  `ls $mseed_folder/$sta | grep BH2`
	do
		./mseed2sac -k $lat/$lon -C 'BHE' $mseed_folder/$sta/$mseedfile
	done
	# Z component
	for mseedfile in  `ls $mseed_folder/$sta | grep BHZ`
	do
		./mseed2sac -k $lat/$lon $mseed_folder/$sta/$mseedfile
	done
	# write elvation & CMP info
	ls *BHN*.SAC | awk '{print "r",$1,"\nch stel '$elv' CMPINC 90 CMPAZ 0","\nwh over"}END{print "quit"}' | sac
	ls *BHE*.SAC | awk '{print "r",$1,"\nch stel '$elv' CMPINC 90 CMPAZ 90","\nwh over"}END{print "quit"}' | sac
	ls *BHZ*.SAC | awk '{print "r",$1,"\nch stel '$elv' CMPINC 0 CMPAZ 0","\nwh over"}END{print "quit"}' | sac
	rm ./mseed2sac

done
	
