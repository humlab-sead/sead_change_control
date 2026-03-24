-- Deploy facet: 20260324_DML_FACET_ABUNDANCE_CLASSIFICATION_TITLE

/****************************************************************************************************************
  Author        Johan von Boer
  Date          2026-03-24
  Description   Fix display_title capitalisation for abundance_classification facet
  Issue         https://github.com/humlab-sead/sead_change_control/issues/419
  Prerequisites
  Reviewer
  Approver
  Idempotent    Yes
  Notes         Changes display_title from 'abundance classification' to 'Abundance classification'
                for facet_id = 31 (facet_code = 'abundance_classification').
*****************************************************************************************************************/

set client_encoding = 'UTF8';
set client_min_messages = error;

begin;

set search_path = facet, pg_catalog;

update facet.facet
set display_title = 'Abundance classification'
where facet_id = 31
  and display_title is distinct from 'Abundance classification';

commit;
