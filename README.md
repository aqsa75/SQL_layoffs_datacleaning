Layoffs Data Cleanup and Standardization

This project focused on preparing a dataset of layoff information for analysis by cleaning, standardizing, and organizing the data for better usability. Key steps included:

Removing Duplicates: Using SQL ROW_NUMBER and PARTITION BY functions, duplicates were identified and removed from the layoffs data to ensure each entry was unique.
Date Standardization: The date field was standardized by converting various date formats into a uniform format. Non-convertible dates were flagged for further review.


Handling Null and Blank Values: Null and blank values in critical fields such as industry, total_laid_off, and percentage_laid_off were handled. Some null fields were filled based on similar entries in the dataset, while others were removed if necessary.


Data Standardization: Fields like company, industry, and country were standardized by trimming extra spaces, correcting capitalization inconsistencies, and grouping similar entries (e.g., all "Crypto" variants under a single label).


Removing Unnecessary Columns and Rows: The temporary row_num column and entries with missing key information (such as both total_laid_off and percentage_laid_off being NULL) were removed to streamline the dataset.
