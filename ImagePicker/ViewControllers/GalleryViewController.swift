
import UIKit
import OpalImagePicker
import Photos

class GalleryViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var pickImage: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var images : [UIImage] = []
    var spasingBetweenCells : CGFloat = 2
    var numberOfItemsPerRow : CGFloat = 2
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        pickImage.layer.cornerRadius = 15
        collectionView.register(ImageCell.nib(), forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(changeCountInRow))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc private func changeCountInRow(recognizer : UIPinchGestureRecognizer){
        if recognizer.state == .ended{
            switch recognizer.scale {
            case 0...1:
                if Int(numberOfItemsPerRow) < images.count {
                    numberOfItemsPerRow += 1
                }
            default:
                if numberOfItemsPerRow > 1 {
                    numberOfItemsPerRow -= 1
                }
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: - Public methods
    public func setImage(_ image :UIImage,withName name : String? = nil){
        images.append(image)
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("jpeg")
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "\(images.count)imageName")
        StorageManager.shared.imagesCount += 1
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    private func loadImage(){
        guard  StorageManager.shared.imagesCount >= 1 else { return }
        for index in 1...StorageManager.shared.imagesCount{
            guard let fileName = UserDefaults.standard.string(forKey: "\(index)imageName") else { return }
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("jpeg")
            guard let savedData = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: savedData) else { return }
            let fixedImage =  image.fixedOrientation
            images.append(fixedImage)
        }
    }
    
    private func showCamera (){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .camera
        present(pickerController,animated: true)
        
    }
    
    private func showLibrary() {
        let imagePicker = OpalImagePickerController()
        presentOpalImagePickerController(imagePicker, animated: true,
                                         select: { (assets) in
            for index in 0...assets.count - 1{
                let img = assets[index].getAssetThumbnail()
                self.setImage(img)
            }
            self.presentedViewController?.dismiss(animated: true)
        }, cancel: {
            self.presentedViewController?.dismiss(animated: true)
        })
    }
    
    // MARK: - IBActions
    @IBAction func pickImage(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showCamera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel)
        let urlAction = UIAlertAction(title: "URL", style: .default){[weak self]  _ in
            let urlAlert = UIAlertController(title: "Enter URL", message: nil, preferredStyle: .alert)
            urlAlert.addTextField{textfield in
                textfield.placeholder = "Enter URL"
            }
            let acceptAction = UIAlertAction(title: "Accept", style: .default){_ in
                let text = urlAlert.textFields?.first?.text ?? ""
                guard let url = URL(string: text) else { return }
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            guard let newImage = UIImage(data: data) else { return }
                            self?.setImage(newImage)
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            urlAlert.addAction(acceptAction)
            urlAlert.addAction(cancelAction)
            self?.present(urlAlert,animated: true)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(urlAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name:String?
        if let imageName = info[.imageURL] as? URL{
            name = imageName.lastPathComponent
        }
        setImage(image,withName: name)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true)
        
    }
}
extension GalleryViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = ShowPhotoViewController()
        destinationViewController.myImageView.image = images[indexPath.row]
        destinationViewController.modalPresentationStyle = .fullScreen
        present(destinationViewController,animated: true)
    }
}

extension GalleryViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ImageCell.identifier, for: indexPath) as?  ImageCell else { return UICollectionViewCell()}
        
        cell.configure(withImage: images[index])
        
        return cell
    }
}

extension GalleryViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = (numberOfItemsPerRow - 1) * spasingBetweenCells
        let width = (collectionView.bounds.width - totalHorizontalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spasingBetweenCells
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spasingBetweenCells
    }
    
}
