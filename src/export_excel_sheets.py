
import pandas as pd
import click
from os.path import join, isfile, isdir

source_filename: str = 'path_to_your_file.xlsx'
target_folder: str = '.'

@click.command()
@click.argument('source_filename')
@click.argument('target_folder')
def export_excel_sheets(source_filename: str, target_folder: str):

    if not isfile(source_filename):
        raise FileNotFoundError(f'File {source_filename} not found')
    
    if not isdir(target_folder):
        raise FileNotFoundError(f'Folder {target_folder} not found')

    xl = pd.ExcelFile(source_filename)
    for sheet_name in xl.sheet_names:
        df = xl.parse(sheet_name)
        df.to_csv(join(target_folder, f'{sheet_name}.csv'), index=False, encoding='utf-8')


if __name__ == '__main__':
    export_excel_sheets()
