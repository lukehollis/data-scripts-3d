cd ~/Projects/spaceshare/spaces/sphinx/mp/
python ~/Projects/spaceshare/downloader/har2files/har2files.py
cd sphinx_paws.my.matterport.com/ 
python ~/Projects/spaceshare/converter/convert_matterport_har.py --model_id 064ce81cf54945aeab70ddb60b9d6ff8 --tour_id DFTYQWxyVWY --tour_title "The Great Sphinx of Giza"
