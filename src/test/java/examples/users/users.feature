
Feature: Automatizar backend PetStore

  Background:
    * url apiPetStore
    * def jsonCrearMascota = read('classpath:examples/jsonData/crearMascota.json')

  @TEST-1 @crearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store - OK
    Given path 'pet'
    And request jsonCrearMascota
    When method post
    Then status 200
    And match response.id == 1
    And match response.name == 'Max'
    And match response.status == 'available'
    * def idPet = response.id
    And print idPet

  @TEST-2
  Scenario Outline: Verificar estado de la mascota en Pet Store - OK

    Given path 'pet/findByStatus'
    And param status = '<estado>'
    When method get
    Then status 200
    And print response

    Examples:
      | estado     |
      | available  |
      | pending    |
      | sold       |

  @TEST-3
  Scenario: Verificar la actualizacion de una nueva mascota previamente registrada en Pet Store - OK
    Given path 'pet'
    And request jsonCrearMascota.id = '3'
    And request jsonCrearMascota.name = 'Boby'
    And request jsonCrearMascota.status = 'sold'
    And request jsonCrearMascota
    When method put
    Then status 200
    And print response

  @TEST-4
  Scenario Outline: Verificar la mascota por ID en Pet Store - OK

    Given path 'pet/' + '<idPet>'
    When method get
    Then status 200
    And print response

    Examples:
      | idPet |
      | 5     |
      | 6     |
      | 7     |

  @TEST-5
  Scenario Outline: Eliminar la mascota por ID en Pet Store - OK

    Given path 'pet/' + '<idPet>'
    When method delete
    Then status 200
    And print response

    Examples:
      | idPet |
      | 5     |
      | 6     |
      | 7     |

    @TEST-6
    Scenario: Verificar que se suba una imagen - OK
      Given path 'pet/', '8', 'uploadImage'
      And multipart file file = { read: 'classpath:examples/imagenes/perrito.jpg', filename: 'perrito.jpg', contentType: 'image/jpeg' }
      And multipart field additionalMetadata = 'Foto de perfil'
      When method post
      Then status 200

  @TEST-7
  Scenario: Verificar la mascota por ID en Pet Store - OK
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')
    Given path 'pet', idMascota.idPet
    When method get
    Then status 200
    And print response



