//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Mikael Joseph Kaufman on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage

// FOR TABLE VIEWS::: ADD 'UITableViewDelegate' and 'UITableViewDataSource'
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add next two lines after adding onto the header
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // THis function is created because it will refresh posts just after creating a new one
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Creating querys (FROM Parse API)
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    // NEXT TWO FUNCTIONS ARE FOR THE TWO ADD ONS FROM THE HEADER
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Creates number of Rows
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creates aspects of cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
