all:
	rsync -pvtrlL --cvs-exclude --delete *css *js *cgi *html data \
		-e ssh nemesis:sites/zoul.fleuron.cz/kotoba/
