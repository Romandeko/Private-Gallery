
import UIKit

class GalleryViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickImage: UIButton!
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        pickImage.layer.cornerRadius = 15
    }
    
    // MARK: - Public methods
    public func setImage(_ image :UIImage,withName name : String? = nil){
        imageView.image = image
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        deletePrevImage()
        try? data.write(to: fileURL)
        UserDefaults.standard.set(fileName, forKey: "imageName")
    }
    
    // MARK: - Private methods
    private func loadImage(){
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let savedData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: savedData) else { return }
        imageView.image = image
    }
    
    private func deletePrevImage(){
        guard let fileName = UserDefaults.standard.string(forKey: "imageName") else { return }
        UserDefaults.standard.removeObject(forKey: "imageName")
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func showPicker (withSourceType sourceType : UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        present(pickerController,animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func pickImage(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
