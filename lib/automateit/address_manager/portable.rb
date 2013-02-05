# == AddressManager::Portable
#
# A pure-Ruby, portable driver for the AddressManager which provides
# minimal support for querying the hostname using sockets. Although it
# lacks advanced features found in other drivers, it will work on all
# platforms.
class AutomateIt::AddressManager::Portable < AutomateIt::AddressManager::BaseDriver
  def suitability(method, *args) # :nodoc:
    return 1
  end

  # See AddressManager#has?
  def has?(opts)
    raise NotImplementedError.new("this driver doesn't support queries for devices or labels") if opts[:device] or opts[:label]
    result = true
    result &= addresses.include?(opts[:address]) if opts[:address]
    return result
  end

  # See AddressManager#hostnames
  def hostnames
    results = []
    results << Socket.gethostname
    results << "localhost"
    results += Socket.gethostbyname(Socket.gethostname)[1] rescue SocketError
    results += results.map{|name| hostnames_for(name)}.flatten
    return results.sort.uniq
  end

  # See AddressManager#addresses
  def addresses
    results = Set.new(["127.0.0.1"])
    results.merge(TCPSocket.gethostbyname(Socket.gethostname)[3]) rescue SocketError
    return results.flatten
  end
end
