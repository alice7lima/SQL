-- New Companies

select a1.company_code, a1.founder, 
count(distinct a2.lead_manager_code),
count(distinct a3.senior_manager_code),
count(distinct a4.manager_code), 
count(distinct a5.employee_code)
from company a1
inner join lead_manager a2
on a1.company_code = a2.company_code
inner join senior_manager a3
on a1.company_code = a3.company_code
inner join manager a4
on a1.company_code = a4.company_code
inner join employee a5
on a1.company_code = a5.company_code
group by a1.company_code, a1.founder
order by a1.company_code;