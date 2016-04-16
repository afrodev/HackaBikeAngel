//
//  MapKitVC.swift
//  HackaBike
//
//  Created by Ezequiel on 4/16/16.
//  Copyright © 2016 Ezequiel. All rights reserved.
//

import UIKit
import MapKit

class MapKitVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GooglePlacesAutocompleteDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Distancia inicial de abrangencia (Zoom)
    let regionRadius: CLLocationDistance = 1000
    
    // Pin da localizacao
    var pinAnnotation: PinAnnotation!
    
    // Busca de enderecos
    var gpaViewController = GooglePlacesAutocomplete(
        // Server API Key, esta na conta do Ramon
        apiKey: "AIzaSyCuUsA5Yw9i59zjSU-cyNOimualxC2HqkM",
        placeType: .Address
    )
    
    // Helpers endereco
    var userAddress: String?
    var userNumber: Int?
    var addressPlace: Place?
    var addressClosed = false
    
    var blurMapBackground = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpaViewController.gpaViewController.delegate = self
        
        // Configurando a mapview
        mapView.delegate = self
        
        // Detectando a posicao atual do usuario em background
        //        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
        //            if let geopoint = geopoint as PFGeoPoint? {
        //                // Guardando a localizacao no tipo CLLocation (para a mapView)
        //                let localizacaoCL = CLLocation(latitude: geopoint.latitude, longitude:geopoint.longitude)
        //
        //                // Adicionando um pin dessa localizacao no mapa
        //                self.adicionarPinAoMapa(geopoint.latitude, longitude: geopoint.longitude)
        //
        //                // Centralizando o mapa
        //                self.centerMapOnLocation(localizacaoCL)
        //                self.gpaViewController.gpaViewController.getPlacesReversed(geopoint.latitude, longitude: geopoint.longitude)
        //            }
        //        }
        
        blurMapBackground.frame.size = screenSize()
        blurMapBackground.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        blurMapBackground.bounds = UIScreen.mainScreen().bounds
        blurMapBackground.alpha = 0.8
    }
    
    /**
     Acao para quando o botao proximo for acionado
     */
    @IBAction func btnProximoAction(sender: AnyObject) {
        if self.userNumber == nil {
            showStreetNumberAlert()
        } else {
            //            // Convertendo a localizacao do pin para um PFGeoPoint, para salvar no Parse
            //            let localizacaoGP = PFGeoPoint(latitude: self.pinAnnotation.coordinate.latitude, longitude: self.pinAnnotation.coordinate.longitude)
            //            // Definindo essa localizacao no usuario
            //            self.usuarioAtual?.setObject(localizacaoGP, forKey: "localizacao");
            //            self.usuarioAtual?.setObject(self.userAddress!, forKey: "endereco");
            //            self.usuarioAtual?.setObject(self.userNumber!, forKey: "numEndereco");
            //            self.performSegueWithIdentifier("segueConfirm", sender: self)
        }
    }
    
    /**
     Metodo helper, que serve pra centralizar o mapa na posicao selecionada
     */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
     Quando ha uma deteccao do gestureRecognizer, esta funcao eh chamada. Convertemos o ponto de onde o usuario tocou, para um ponto no mapa, pegando assim as coordenadas para adicionar o respectivo pin
     */
    func handleLongPressGesture(sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended {
            self.mapView.removeGestureRecognizer(sender)
        } else {
            let point = sender.locationInView(self.mapView)
            let locCord = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
            
            self.adicionarPinAoMapa(locCord.latitude, longitude: locCord.longitude)
            gpaViewController.gpaViewController.getPlacesReversed(locCord.latitude, longitude: locCord.longitude)
            
        }
    }
    
    /**
     Adiciona uma notacao ao mapa, conforme as coordenadas passadas por parametro
     */
    func adicionarPinAoMapa(latitude: Double, longitude: Double){
        if (self.pinAnnotation != nil) {
            self.mapView.removeAnnotation(self.pinAnnotation)
        }
        
        self.pinAnnotation = PinAnnotation()
        self.pinAnnotation.setCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        self.pinAnnotation.title = "Endereço a ser salvo"
        
        self.mapView.addAnnotation(self.pinAnnotation)
        self.mapView.selectAnnotation(self.pinAnnotation, animated: true)
    }
    
    /*
     (delegate) Definimos as propriedades do pin
     */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinTintColor = UIColor(red: 99/255, green: 71/255, blue: 92/255, alpha: 0.75)
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            return pinAnnotationView
        }
        return nil
    }
    
    @IBAction func changeAddress(sender: AnyObject) {
        self.userNumber = nil
        
        self.view.addSubview(blurMapBackground)
        UIView.animateWithDuration(0.2, animations: {self.blurMapBackground.alpha = 0.8}, completion: nil)
        
        gpaViewController.placeDelegate = self
        gpaViewController.modalPresentationStyle = .OverCurrentContext
        // Apresenta a view controller
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func placeSelected(place: Place) {
        self.addressPlace = place
        placeViewSave()
    }
    
    func placeViewClosed() {
        UIView.animateWithDuration(0.2, animations: {self.blurMapBackground.alpha = 0.0},
                                   completion: {(value: Bool) in
                                    self.blurMapBackground.removeFromSuperview()
                                    self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    
    func placeViewSave() {
        self.addressPlace?.getDetails { details in
            // Passando o endereco (string) que foi selecionado na API GPlaces para a nossa class
            self.userAddress = details.fullAddress
            
            let localizacaoCL = CLLocation(latitude: details.latitude, longitude:details.longitude)
            
            // Adicionando um pin dessa localizacao no mapa
            self.adicionarPinAoMapa(details.latitude, longitude: details.longitude)
            
            // Centralizando o mapa
            self.centerMapOnLocation(localizacaoCL)
        }
        self.placeViewClosed()
    }
    
    func geocodingAddressFound(address: String) {
        self.userAddress = address
        self.showStreetNumberAlert()
    }
    
    func showStreetNumberAlert() {
        let alert = SCLAlertView()
        alert.shouldDismissOnTapOutside = true
        alert.setBodyTextFontFamily("FiraSans-Light", withSize: 17)
        alert.setTitleFontFamily("FiraSans-Regular", withSize: 17)
        alert.setButtonsTextFontFamily("FiraSans-Light", withSize: 17)
        alert.customViewColor = UIColor.grayColor()
        let txt = alert.addTextField("")
        txt.keyboardType = .NumberPad
        alert.addButton("Salvar") { () -> Void in
            if txt.text?.isEmpty == false {
                self.userNumber = ((txt.text as String!) as NSString).integerValue
            }
        }
        alert.showEdit(self, title: "Informar número", subTitle: "O endereço selecionado é \(self.userAddress!). Caso esteja de acordo, informe o número abaixo:", closeButtonTitle: "Alterar endereço", duration: 0.0)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.Ending {
            gpaViewController.gpaViewController.getPlacesReversed(self.pinAnnotation.coordinate.latitude, longitude: self.pinAnnotation.coordinate.longitude)
        }
    }
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }
}