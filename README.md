# publications_dblp_xslt

## Introduciton

DBLP is an online bibliographical database for computer science publications containing around 1.6 million references. Its content is publically available in XML format. Since this content is more than 800 MB a small excerpt of this data will be used for this project.

In essence, the `dblp.xml` file describes a collection of DBLP records:
```
<?xml version="1.0" encoding="ISO-8859-1">
<!DOCTYPE dblp SYSTEM "dblp.dtd">
<dblp>
    record 1 
    record 2 
    ... 
    record n
</dblp>

```

Each record in the collection describes a bibliographic reference of a publication. These publications can be of 8 types: `article`, `inproceedings`, `proceedings`, `book`, `incollection`, `phdthesis`, `mastersthesis`, and `www` following the ad-hoc BibTeX format.
Depending on the publication type, records can mention the following fields: `author`, `editor`, `title`, `booktitle`, `pages`, `year`, `address`, `journal`, `volume`, `number`, `month`, `url`, `ee`, `cdrom`, `cite`, `publisher`, `note`, `crossref`, `isbn`, `series`, `school`, and `chapter`. Notice that not all fields are allowed in all publication types; please refer to the DBLP DTD file dblp.dtd and the DBLP de- scription paper at http://dblp.uni-trier.de/xml/docu/dblpxml.pdf for detailed information on the different publication types and their allowed fields.

## Goal

The goal of this project is to write a single XSLT 2.0 stylesheet that generates, from the `dblp-excerpt.xml` file, a number of HTML files that together collectively emulates part of the DBLP website.
Concretely, for each distinct person name P found in a author or editor field of some record in the dbpl.xml file the stylesheet should generate a file

___a-tree/first-letter-of-lastname /lastname.firstname.html___

For example, for the author “David Maier”, the file a-tree/m/Maier.David.html should be created, whereas for “Michael Ley”, the file a-tree/l/Ley.Michael.html should be created. Blanks should be mapped to underscores; all other characters which are not alphanumeric should be mapped to ‘=’. This avoids illegal filenames/URLs.
The contents of the HTML file for person P should consist of the following parts.
1. The person’s name in a `h1` tag.
1. Followed by a table of all of the person’s publications, grouped per year (sorted descending on year and subsequently on publication title). Apart from the rows that indicate the beginning of a new year, each row in this table should be of the form `publication number, link to online version, publication reference`
1. Followed by “Co-author index” in a `h2` tag.
1. Followed by a table listing all other persons with whom P has jointly published. For each such co-author, there should be a row describing the pair (_co-author-name_, _list-of-references-to-joint-publications_). Each reference in this list should link to the corresponding publication in the publication table. The table should be sorted by co-author lastname.

## Usage

On full data:

`java -jar xslt-tool.jar src/generate-author-pages.xslt data/dblp-exceprt.xml a-tree`

On test data only:

`java -jar xslt-tool.jar src/generate-author-pages.xslt data/dblp-test.xml a-tree`

Explore results in folder `a-tree`.