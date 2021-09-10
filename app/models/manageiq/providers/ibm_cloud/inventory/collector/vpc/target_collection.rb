class ManageIQ::Providers::IbmCloud::Inventory::Collector::VPC::TargetCollection < ManageIQ::Providers::IbmCloud::Inventory::Collector::VPC
  def initialize(_manager, _target)
    super

    parse_targets!
  end

  def images
    @images ||=
      references(:miq_templates).map do |ems_ref|
        connection.request(:get_image, :id => ems_ref)
      end
  end

  def vms
    @vms ||=
      references(:vms).map do |ems_ref|
        connection.request(:get_instance, :id => ems_ref)
      end
  end

  def instance_types
    []
  end

  def flavors
    @flavors ||=
      references(:flavors).map do |ems_ref|
        connection.request(:get_instance_profile, :name => ems_ref)
      end
  end

  def keys
    []
  end

  def availability_zones
    []
  end

  def security_groups
    []
  end

  def cloud_networks
    []
  end

  def cloud_subnets
    []
  end

  def floating_ips
    []
  end

  def volumes
    []
  end

  def cloud_volume_types
    []
  end

  def resource_groups
    []
  end

  private

  def parse_targets!
    # `target` here is an `InventoryRefresh::TargetCollection`.  This contains two types of targets,
    # `InventoryRefresh::Target` which is essentialy an association/manager_ref pair, or an ActiveRecord::Base
    # type object like a Vm.
    #
    # This gives us some flexibility in how we request a resource be refreshed.
    target.targets.each do |target|
      case target
      when MiqTemplate
        add_target(:miq_templates, target.ems_ref)
      when Vm
        add_target(:vms, target.ems_ref)
      when Flavor
        add_target(:flavors, target.ems_ref)
      end
    end
  end

  def add_target(association, ems_ref)
    return if ems_ref.blank?

    target.add_target(:association => association, :manager_ref => {:ems_ref => ems_ref})
  end

  def references(collection)
    target.manager_refs_by_association&.dig(collection, :ems_ref)&.to_a&.compact || []
  end
end
