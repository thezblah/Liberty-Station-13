/*
	Department Datums
	Currently only used for a non-shitcode way of having variable initial balances in department accounts
	in future, should be a holder for job datums
*/

/datum/department
	var/name = "unspecified department"	//Name may be shown in UIs, proper capitalisation
	var/id	= "department" //This should be one of the DEPARTMENT_XXX defines in __defines/jobs.dm
	var/account_number = 0
	var/account_pin
	var/account_initial_balance = 3500	//How much money this account starts off with
	var/list/jobs_in_department = list()

	// With external, this is the name of an organisation
	// Adding a funding source makes the game pay them out of thin air.
	// Adding in a department flag (see liberty-station/code/__DEFINES/jobs.dm) will make it draw form said account to wire funds for payment of wages.
	// This is takes form the source budget_bage + wages per person
	var/funding_source

	// Budget for misc department expenses, paid regardless of it being manned or not
	var/budget_base = 0

	// Budget for crew salaries. Summed up initial wages of department's personnel
	var/budget_personnel = 0


	// How much account failed to pay to employees. Used for emails
	var/total_debt = 0

/datum/department/proc/get_total_budget()
	if(funding_source)
		return budget_base + budget_personnel
	else
		return FALSE

/*************
	Command
**************/
/datum/department/command
	name = "Liberty Council"
	id = DEPARTMENT_COMMAND
	account_initial_balance = 2000000
	jobs_in_department = list(JOBS_COMMAND)

/*************
	Retainers
**************/
//These departments are paid out of ship funding
/datum/department/ironhammer
	name = "Liberty Watch Funds"
	id = DEPARTMENT_SECURITY
	jobs_in_department = list(JOBS_SECURITY)

/datum/department/terra_therma
	name = "Terra-Therma Union Funds"
	id = DEPARTMENT_ENGINEERING
	jobs_in_department = list(JOBS_ENGINEERING)

/datum/department/service
	name = "Liberty Contractors"
	id = DEPARTMENT_CIVILIAN
	account_initial_balance = 0
	jobs_in_department = list()

/******************
	Benefactors
*******************/
//Departments subsidised by an external organisation. These pay their own employees
/datum/department/medical
	name = "Chirurgeons And Pharmaceutical Sciences Association Funds"
	id = DEPARTMENT_MEDICAL
	jobs_in_department = list(JOBS_MEDICAL)

/datum/department/research
	name = "Phokorus Science Institute Funds"
	id = DEPARTMENT_SCIENCE
	jobs_in_department = list(JOBS_SCIENCE)

/datum/department/church
	name = "Custodians of Bonfires Funds"
	id = DEPARTMENT_CHURCH
	account_initial_balance = 17000 //17000 to cover some expenses but not that much
	//Full team with nepotism in 5 hours is 15600
	jobs_in_department = list (JOBS_CHURCH)

/******************
	Independant
*******************/
//Self funds and pays wages out of its earnings
/datum/department/service
	name = "Skylight Syndicate Funds"
	id = DEPARTMENT_SERVICE
	jobs_in_department = list(JOBS_SERVICE)

/datum/department/prospector
	name = "Fontaine Heavy Industries Funds"
	id = DEPARTMENT_PROSPECTOR
	jobs_in_department = list(JOBS_PROSPECTOR)

/datum/department/independent
	name = "Independent Allied Factions"
	id = DEPARTMENT_INDEPENDENT
	jobs_in_department = list("/datum/job/assistant")

/datum/department/similacrum_positronic
	name = "Similacrum Robotics"
	id = DEPARTMENT_SIMILACRUM
	jobs_in_department = list()


///////////////////////DEPARTMENT EXPERIENCE PERKS//////////////////////////////////////////

/datum/perk/experienced
	name = "Experienced: HOLDER"
	desc = "This is only a test."
	active = FALSE
	passivePerk = FALSE
	var/subPerk = FALSE
	var/datum/department/dept




/datum/perk/experienced/activate()
	..()
	var/list/perkChoice
	var/paths = subtypesof(type)
	for (var/T in paths)
		var/datum/perk/experienced/checker = new T
		if (checker)
			if ((checker.dept == dept)&&(checker.subPerk))
				perkChoice += list(checker)

	var/datum/perk/experienced/choice = input("Hey, this is the first text.", "SECOND!", FALSE) as anything in perkChoice
	if (istype(choice,/datum/perk/experienced))
		holder.stats.addPerk(choice.type)
	holder.stats.removePerk(type)

///////////////////////////////
//EXPERIENCED PERKS
//
//When the base Department perk is clicked, it will search all subtypes of the /datum/perk/experienced/<<DEPARTMENT>>/ folder for all subperks of that particular kind.
//It will then present an input choice list as to what "Sub-Perk" they would like to choose for being experienced.
//////////////////////////////


/datum/perk/experienced/Prospector
	name = "Experienced: Prospector"
	gain_text = "Did it work?"
	dept = DEPARTMENT_PROSPECTOR

/datum/perk/experienced/Prospector/ThingOne
	subPerk = TRUE
	name = "Experienced: Prospector - Thing One Check"   /////Use this format. Or don't?
	gain_text = "Alright, you're scaring me..."

/datum/perk/experienced/Science
	name = "Experienced: Science"
	gain_text = "Well, that apparently worked?"
	desc = "Hm....."
	dept = DEPARTMENT_SCIENCE

/datum/perk/experienced/Medical
	name = "Experienced: Medical"
	dept = DEPARTMENT_MEDICAL

/datum/perk/experienced/Skylight
	name = "Experienced: Skylight"
	dept = DEPARTMENT_SERVICE
	gain_text = "Yay? Skylight!!!"

/datum/perk/experienced/Skylight/Station
	subPerk = TRUE
	name = "Station?"
	gain_text = "STATION!"
	desc = "Station."

/datum/perk/experienced/Skylight/DoubleTrouble
	subPerk = TRUE
	name = "BOUBLE TWOBLE!"
	gain_text = "I knojsdklakfdj;af"
	desc = "Another boring description"

/datum/perk/experienced/Cult
	name = "Experienced: Church of the Gamer Word"
	dept = DEPARTMENT_CHURCH

/datum/perk/experienced/Service
	name = "Experienced: Service Worker"
	dept = DEPARTMENT_CIVILIAN

/datum/perk/experienced/artificers
	name = "Experienced: Terra-Therma Union"
	dept = DEPARTMENT_ENGINEERING

/datum/perk/experienced/shitcurity
	name = "Experienced: Shitcurity"
	dept = DEPARTMENT_SECURITY

/datum/perk/experienced/unaligned
	name = "Experienced: Other"
	dept = DEPARTMENT_INDEPENDENT

//No, there is no experience perk for the Premiere, as the point of the position is suffering.
