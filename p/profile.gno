// A profile is the view of an address and it shows all the information the
// user wants to share, besides the badges (which can be discussed if should
// be optional for the user) and other things

package gnowledgetools

import (
	std "std"
	"strconv"
	"strings"

	avl "gno.land/p/demo/avl"
	ufmt "gno.land/p/demo/ufmt"
)

// Errors
const (
	ErrNoData        = "No data of this user"
	ErrRegisterFirst = "Register First!"
)

// Contains the main components of the user
type Data struct {
	Name               string
	NickName           string
	Location           string
	Description        string
	Connections        avl.Tree        // Address (str) -> true (To record connections made)
	Experience         []JobExperience // JobExperience Positions ordered by years
	Skills             avl.Tree        // Associates the skill with the job(s) that are registered.
	Networks           avl.Tree        // network_name -> link to reference (Github, Twitter, etc)
	pendingConnections avl.Tree        // Address (str) -> true (To record one-direction connections. Only the owner can have access to this)
}

type JobExperience struct {
	Title          string   // The type of your job
	EmploymentType string   // Employment type. This has to be defined
	Company        string   // (Here should be a way to prove the validation of this Company)
	Location       string   // Location of company
	LocationType   string   // Onsite, hybrid, remote.
	Current        bool     // If it's still working there or not
	StartDate      string   // Starting date of the position
	EndDate        string   // Ending date of the position
	Description    string   // Description of the tasks and responsibilities in the job
	SkillsRequired avl.Tree // These have to match with the avl.Tree the member has in his Data. Otherwise has to update that first
}

// Update certain data from the Data section of the user
func UpdateData(name, location, description string, site avl.Tree) {
	// You can only update your own id
	caller := std.GetOrigCaller().String()
	dataInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrNoData)
	}
	data := dataInterface.(Data)
	if name != "" && len(name) > 5 {
		data.Name = name
	}
	if description != "" && len(description) > 5 {
		data.Description = description
	}
	if location != "" {
		data.Location = location
	}
	if description != "" {
		data.Description = description
	}
	site.Set(caller, data)
}

func updateNetwork(user Data, website string, path string) {
	user.Networks.Set(website, path)
}

// Add a job experience for yourself
// The order will be done by the website
func AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription string, site avl.Tree) {
	caller := std.GetOrigCaller().String()
	userDataInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrRegisterFirst)
	}
	userData := userDataInterface.(Data)
	actual := false
	if current != "" {
		actual = true
	}
	newJob := generateJobExperience(Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription, actual)
	Experience := append(userData.Experience, newJob)
	userData.Experience = Experience
	site.Set(caller, userData)
}

func AddNetwork(network, path string, site avl.Tree) {
	caller := std.GetOrigCaller().String()
	userInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrNoData)
	}
	user := userInterface.(Data)
	updateNetwork(user, network, path)
}

func generateJobExperience(Title, EmploymentType, Company, Location, StartDate, EndDate, Description string, current bool) JobExperience {
	return JobExperience{
		Title:          Title,
		EmploymentType: EmploymentType,
		Company:        Company,
		Location:       Location,
		StartDate:      StartDate,
		EndDate:        EndDate,
		Description:    Description,
		Current:        current,
	}
}
