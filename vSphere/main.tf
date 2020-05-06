resource "vsphere_tag_category" "category" {
  name        = "terraform-test-category"
  description = "description"
  cardinality = "MULTIPLE"

  associable_types = [
    "Datacenter"
  ]
}

resource "vsphere_tag" "tag1" {
  name        = "environment"
  category_id = "${vsphere_tag_category.category.id}"
  description = "description"
}

resource "vsphere_tag" "tag2" {
  name        = "team"
  category_id = "${vsphere_tag_category.category.id}"
  description = "description"
}

resource "vsphere_tag" "tag3" {
  name        = "appname"
  category_id = "${vsphere_tag_category.category.id}"
  description = "description"
}


resource "vsphere_datacenter" "storage" {
  name       = "KubeStorage"
  tags = ["${vsphere_tag.tag1.id}","${vsphere_tag.tag2.id}","${vsphere_tag.tag3.id}"]
}

resource "vsphere_datacenter" "cluster" {
  name       = "KubeCluster"
  tags = ["${vsphere_tag.tag1.id}","${vsphere_tag.tag2.id}","${vsphere_tag.tag3.id}"]
}

resource "vsphere_datacenter" "vault" {
  name       = "KubeVault"
  tags = ["${vsphere_tag.tag1.id}","${vsphere_tag.tag2.id}","${vsphere_tag.tag3.id}"]
}

resource "vsphere_datacenter" "registry" {
  name       = "KubeRegistry"
  tags = ["${vsphere_tag.tag1.id}","${vsphere_tag.tag2.id}","${vsphere_tag.tag3.id}"]
}

resource "vsphere_datacenter" "jumpbox" {
  name       = "KubeJumpbox"
  tags = ["${vsphere_tag.tag1.id}","${vsphere_tag.tag2.id}","${vsphere_tag.tag3.id}"]
}
