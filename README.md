# ORCID api name check

Script to query ORCID public api for names affiliated with UC

## Usage (Python)
#### Requirements
* Python version 3.6+
* Pip for Python 3

#### Setup
* Install dependencies using `pip3 install -r "requirements.txt"`
* Add a `names.csv` to the directory with the names you want to query in ORCID
* Edit `check_names.py` and add your ORCID API token

#### Running 
* Run with `python3 check_names.py`

## Usage (Ruby)
#### Requirements
* Ruby version 2.4+
 
#### Setup
* Install namae gem using `gem install namae`
* Add a `names.csv` to the directory with the names you want to query in ORCID
* Edit `check_names.rb` and add your ORCID API token

#### Running 
* Run with `ruby check_names.rb`
