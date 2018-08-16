
import Siesta
import UIKit

class RestaurantListViewController: UIViewController {

  static let locations = ["Atlanta", "Boston", "Chicago", "Los Angeles", "New York", "San Francisco"]

  @IBOutlet weak var tableView: UITableView!
  
  private var statusOverlay = ResourceStatusOverlay()

  
  // "restaurants" gets set inside the Protocol function and as soon as it gets set, we need to inform tableView to
  // show the right content.
  private var restaurants: [Restaurant] = []{
    didSet {
      tableView.reloadData()
    }
  }
  
  
  // Whenever user changes the location, you need to display right list of restauraunts (right content) and so
  // you get the right data. It uses YelpApi to get the right data and returns the Resource Object. You store the
  // returned Resource object in a variable.
  var currentLocation: String! {
    didSet {
      restaurantListResource = YelpAPI.sharedInstance.restaurantList(for: currentLocation)
    }
  }
  

  // Remember, you will only get the data if you "keep observing" for it. And so, we set ".self" as an observer.
  // Since, we have set ".self" as an observer, it needs to conform to the protocol.

  // This variable will be loaded in the background thread.
  var restaurantListResource: Resource? {
    // didSet : basically does the thing whenever the property gets changed. ( possible from anywhere).
    didSet {
      oldValue?.removeObservers(ownedBy: self)
      restaurantListResource?
        
        // This line is necessay as you always have to keep adding yourself (viewController) as an Obeserver
        // for each new Resource
        .addObserver(self)
        .addObserver(statusOverlay, owner: self)
      //  Tell Siesta to load data for the resource if needed (based on the cache expiration timeout).
        .loadIfNeeded()
    }
  }

  
  
  
  
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentLocation = RestaurantListViewController.locations[0]
    tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: "RestaurantListTableViewCell")
    statusOverlay.embed(in : self)
  }
  // This function ensures that the indicator is diplayed in the right position.
  override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews()
    statusOverlay.positionToCoverParent()
  }
}



// MARK: - UITableViewDataSource
extension RestaurantListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell",
                                             for: indexPath) as! RestaurantListTableViewCell
    print (indexPath.row)
    print("Hey I am Inside")

    guard indexPath.row <= restaurants.count else {
      return cell
    }

    let restaurant = restaurants[indexPath.row]
    cell.nameLabel.text = restaurant.name
    cell.iconImageView.imageURL = restaurant.imageUrl
    return cell
  }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.row <= restaurants.count else {
      return
    }
    // Enables the navigation to "Restaurant Detail View Controller" 
    let detailsViewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "RestaurantDetailsViewController")
      as! RestaurantDetailsViewController
    detailsViewController.restaurantId = restaurants[indexPath.row].id
    navigationController?.pushViewController(detailsViewController, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = RestaurantListTableViewHeader()
    headerView.delegate = self
    headerView.location = currentLocation
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}

// MARK: - RestaurantListTableViewHeaderDelegate
extension RestaurantListViewController: RestaurantListTableViewHeaderDelegate {
  func didTapHeaderButton(_ headerView: RestaurantListTableViewHeader) {
    print("Hey, The header button was tapped")
    let locationPicker = UIAlertController(title: "Select location", message: nil, preferredStyle: .actionSheet)
    for location in RestaurantListViewController.locations {
      locationPicker.addAction(UIAlertAction(title: location, style: .default) { [weak self] action in
        guard let `self` = self else { return }
        self.currentLocation = action.title
        self.tableView.reloadData()
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    locationPicker.addAction(cancelAction)
    present(locationPicker, animated: true)
  }
}

// MARK: - ResourceObserver

// In order to always recieve the updated value or get notified, you have to conform to ResourceObserverProtocol
// This function will always be called whenever the Resource data changes.
extension RestaurantListViewController: ResourceObserver {
  func resourceChanged(_ resource: Resource, event: ResourceEvent) {
    restaurants = resource.typedContent() ?? []
//    print(restaurants)
    
  }
}
