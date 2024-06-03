package gnowledge

import (
	"std"
	"strconv"
	"strings"

	ufmt "gno.land/p/demo/ufmt"

	avl "gno.land/p/demo/avl"

	gnowledgetools "gno.land/p/dev/gnowledgetools"
)

// Register yourself in the realm
func Register() {
	caller := std.GetOrigCaller().String()
	site.Set(caller, gnowledgetools.Data{})
}

// Update certain data from the Data section of the user
func UpdateData(name string, location string, description string) {
	// You can only update your own id
	caller := std.GetOrigCaller().String()
	dataInterface, ok := site.Get(caller)
	if !ok {
		panic(ErrNoData)
	}
	data := dataInterface.(gnowledgetools.Data)
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

func ReadUser(address string) string {
	output := gnowledgetools.ReadUser(site, address)
	return output
}

func AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription string) {
	gnowledgetools.AddJob(current, Title, EmploymentType, Company, Location, StartDate, EndDate, JobDescription, site)
}

func AddNetwork(network, path string) {
	gnowledgetools.AddNetwork(network, path, site)
}
