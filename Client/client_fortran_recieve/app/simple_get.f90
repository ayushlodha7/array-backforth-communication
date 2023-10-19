program simple_get

    use http, only: HTTP_GET, request, response_type

    implicit none

    type(response_type) :: response
    character(len=:), allocatable :: ip_address  ! Variable to hold the input IP address
    character(len=:), allocatable :: url         ! Complete URL for the request

    ! Get the IP address (with port) from the command line
    call get_command(ip_address)

    ! Construct the complete URL using the IP address
    url = 'http://' // trim(ip_address) // ':8080/data'
    write(*, '(*(a))') 'Requesting array from: ', url

    ! Send a GET request to the Python server
    response = request(url)

    ! Check if the request was successful
    if (.not. response%ok) then
        write(*, '(*(a))') 'Error message: ', trim(response%err_msg)
    else
        ! Print the response details
        write(*, '(*(a))') 'Response Code    :', response%status_code
        write(*, '(*(a))') 'Response Length  :', response%content_length
        write(*, '(*(a))') 'Response Method  :', response%method
        write(*, '(*(a))') 'Response Content :', response%content
    end if

contains

    ! Subroutine to get the IP address (with port) from the command line
    subroutine get_command(ip_address)
        character(len=:), allocatable, intent(out) :: ip_address
        character(len=100) :: ip_address_temp

        call GET_COMMAND_ARGUMENT(1, ip_address_temp)

        ! Validate that an IP was provided
        if (ip_address_temp == "") then
            write(*, '(*(a))') "Please provide an IP address (with port, if not default)."
            stop
        end if

        ! Transfer the address to the output variable and deallocate any unnecessary memory
        ip_address = trim(ip_address_temp)
    end subroutine get_command

end program simple_get
