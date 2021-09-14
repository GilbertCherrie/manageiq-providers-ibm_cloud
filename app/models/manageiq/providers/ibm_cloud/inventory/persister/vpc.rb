class ManageIQ::Providers::IbmCloud::Inventory::Persister::VPC < ManageIQ::Providers::IbmCloud::Inventory::Persister
  require_nested :CloudManager
  require_nested :NetworkManager
  require_nested :StorageManager
  require_nested :TargetCollection

  def self.provider_module
    "ManageIQ::Providers::IbmCloud::VPC"
  end

  def initialize_inventory_collections
    initialize_tag_mapper
    initialize_cloud_inventory_collections
    initialize_network_inventory_collections
    initialize_storage_inventory_collections
  end

  def initialize_cloud_inventory_collections
    add_cloud_collection(:vms)
    add_cloud_collection(:cloud_databases)
    add_cloud_collection(:hardwares)
    add_cloud_collection(:availability_zones)
    add_cloud_collection(:operating_systems)
    add_cloud_collection(:disks)
    add_cloud_collection(:auth_key_pairs)
    add_cloud_collection(:miq_templates)
    add_cloud_collection(:flavors)
    add_cloud_collection(:vm_and_miq_template_ancestry)
    add_cloud_collection(:networks)
    add_cloud_collection(:vm_and_template_labels)
    add_cloud_collection(:vm_and_template_taggings)
    add_cloud_collection(:resource_groups)
    add_cloud_database_flavors
  end

  def initialize_network_inventory_collections
    add_network_collection(:security_groups)
    add_network_collection(:cloud_networks)
    add_network_collection(:cloud_subnets)
    add_network_collection(:floating_ips)
    add_network_collection(:network_ports)
    add_network_collection(:cloud_subnet_network_ports)
    add_network_collection(:load_balancers)
  end

  def initialize_storage_inventory_collections
    add_storage_collection(:cloud_volumes)
    add_storage_collection(:cloud_volume_types)
  end

  def add_cloud_database_flavors(extra_properties = {})
    add_collection(cloud, :cloud_database_flavors, extra_properties) do |builder|
      builder.add_properties(:strategy => :local_db_find_references) if targeted?
    end
  end
end
