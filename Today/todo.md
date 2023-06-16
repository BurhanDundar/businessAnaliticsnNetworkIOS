#  Yapılacaklar
1. Side menu yapılacak
2. Profile sayfası yapılacak
    - Fotoğraf yükleme ve bunu kaydetme
    - Açıklama Ekleme ve Güncelle
    - Bildirim ve mail almak istediğin kişileri ayarla
    
    - alt tarafta isim takma isim ve açıklama
    - sağ tarafta takip ettiği kişiler (favladığı)
    - takip ettiği şirketler
    - takip ettiği memberler
     
3. Mesajlaşma sistemi yapılacak
4. Mail sistemi kurulacak

#  Yapılsa iyi olur
yukarıdan bookmarked segmentationa basıldığında async task ile veriler veritabanından gelmeli. Şimdilik swift içi array ile denedim ama bakıcam buna
sonra dönücem bu bookmark olayına

change full name olmasına gerek yok heralde değil mi bunu tartışın
alertler ve present hakkında detaylı araştırma yap

let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
NSLog("The \"OK\" alert occured.")
}))
self.present(alert, animated: true, completion: nil)

loadImage içerisinde default user ve company resimlerine bakarsın bi oldu mu diye
