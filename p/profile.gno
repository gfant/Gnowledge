// A profile is the view of an address and it shows all the information the
// user wants to share, besides the badges (which can be discussed if should
// be optional for the user) and other things

package stackovergnotools

import (
	std "std"
	"strconv"
	"strings"

	avl "gno.land/p/demo/avl"
	ufmt "gno.land/p/demo/ufmt"
)

// Errors
const (
	ErrNoData = "No data of this user"
)

// Get the information of a given address
func GetUser(addr string) string {
	userInterface, ok := site.Get(addr)
	if !ok {
		return ""
	}
	user := userInterface.(Data)
	userContent := outputInformation(user)
	return userContent
}

// Stringifies the output
// Based on future enhacements of realm output can be edited
func outputInformation(user Data) string {
	var output string
	experience := ""
	for _, e := range user.Experience {
		experience += readJobExperience(e)
	}

	networks := readNetworks(user.Networks)
	networkTitle := ""
	if networks != "" {
		networkTitle = "## Networks"
	}
	output += ufmt.Sprintf(`# %s
<center>%s</center>
<center>(%s)</center>

%s
%s

## Experience
%s`, user.Name, user.Description, user.Location, networkTitle, networks, experience)
	return output
}

// Update certain data from the Data section of the user
func UpdateData(name string, location string, description string) {
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

func updateNetwork(user Data, website string, path string) {
	user.Networks.Set(website, path)
}

func GenerateJobExperience(current bool, Title string, EmploymentType string, Company string, Location string, StartDate string, EndDate string, Description string) JobExperience {
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

func readJobExperience(content JobExperience) string {
	working := ""
	if content.Current == true {
		working = "(c)"
	}
	output := ufmt.Sprintf(`### >> %s at %s %s
<code> (%s-%s) %s </code>
#### About the job
%s

`, content.Title, content.Company, working, content.StartDate, content.EndDate, content.EmploymentType, content.Description)
	return output
}

func readNetworks(networks avl.Tree) string {
	output := ""
	networks.Iterate("", "", func(key string, value interface{}) bool {
		output += ufmt.Sprintf("[%s](%s)\n\n", key, value)
	})
	return output
}
