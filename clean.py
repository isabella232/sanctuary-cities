#!/usr/bin/python
import csv

from datetime import datetime


def process_csv(filename):
    with open('data/%s' % filename, 'rU') as f:
        reader = csv.DictReader(f)
        writecsv(reader, filename)


def writecsv(data, filename):
    fieldnames = ['date', 'lift_reason', 'det_facility', 'city', 'state', 'detainer_type']
    with open('processed/%s' % filename, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        for row in data:
            date = row.get('Prepare Date')
            if date:
                parsed_date = datetime.strptime(date, '%m/%d/%y')
                postgres_date = parsed_date.strftime('%Y-%m-%d')
            full_row = {
                'date': postgres_date,
                'lift_reason': row.get('Detainer Lift Reason'),
                'det_facility': row.get('Detainer Detention Facility'),
                'city': row.get('City'),
                'state': row.get('State'),
                'detainer_type': row.get('Detainer Type')
            }
            writer.writerow(full_row)


if __name__ == '__main__':
    for filename in ['lea-detainers-FY08.csv', 'lea-detainers-FY09.csv', 'lea-detainers-FY10.csv', 'lea-detainers-FY11_12.csv', 'lea-detainers-FY13_14.csv', 'lea-detainers-FY15YTD.csv']:
        process_csv(filename)
