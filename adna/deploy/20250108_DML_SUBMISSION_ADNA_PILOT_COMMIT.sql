-- Deploy adna: 20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT
/***************************************************************************
  Author         Roger Mähler
  Date           
  Description    
  Issue          
  Prerequisites  
  Reviewer
  Approver
  Idempotent     NO
  Notes          Use --single-transaction on execute!
***************************************************************************/
set client_encoding = 'UTF8';
set client_min_messages to warning;
\set autocommit off;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', true, false);
end $$ language plpgsql;

begin;
set constraints all deferred;
\cd /repo/adna/deploy
\o /dev/null
select clearing_house_commit.reset_public_sequence_ids();
select clearing_house_commit.commit_submission('20250108_DML_SUBMISSION_ADNA_PILOT_COMMIT');
\o
commit;

do $$
begin
    perform sead_utility.set_fk_is_deferrable('public', false, false);
end $$ language plpgsql;

