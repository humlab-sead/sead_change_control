-- Deploy general: 20221206_DML_SITE_DESCRIPTION_HOGDAL_UPDATE

/****************************************************************************************************************
  Author        Roger Mähler
  Date          2019-01-01
  Description
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes
*****************************************************************************************************************/

begin;

    update tbl_sites
        set
            site_description = 'Sites added together, because it is not possible to separate the samples. Coordinates for Hogdal 445.'
        where
            site_description = 'Lat 59° 0'' 2,25"
Long 11° 13'' 57,29"

Coordinates for Hogdal 445

Sites added together, because it is not possible to seperate the samples.
';

commit;
