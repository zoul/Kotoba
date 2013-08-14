all: upload
upload:
	rsync -pvtrlL --cvs-exclude --delete Web/ cirdan:websites/kotoba.cz
