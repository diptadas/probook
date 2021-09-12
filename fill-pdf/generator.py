# !pip3 install fillpdf

from fillpdf import fillpdfs

print(fillpdfs.get_form_fields("template.pdf"))

names = ['John De', 'Andrew Rob', "Mike Kyle"]
date = '12 August 2021'
template = 'template.pdf'

for name in names:
    data_dict = {
        'Name': name,
        'Date': date,
    }
    output = 'certificate_' + name + '.pdf'
    fillpdfs.write_fillable_pdf(template, output, data_dict)
    fillpdfs.flatten_pdf(output, output)
