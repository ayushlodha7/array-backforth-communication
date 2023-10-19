program simple_post

    use http, only: HTTP_POST, request, response_type, pair_type
    implicit none

    type(response_type) :: response
    type(pair_type), allocatable :: headers(:)
    character(len=:), allocatable :: ip_address
    character(len=:), allocatable :: url, data
    real(8), allocatable :: array(:) ! Use double precision here
    integer :: i
    character(len=20) :: num_str

    ! Example array data
    array = [1.0d0, 2.0d0, 3.0d0, 4.0d0, 5.1d0] ! Adjust the values for double precision

    ! Convert array to a comma-separated string for simplicity
    data = ""
    do i = 1, size(array)
        write(num_str, '(f20.5)') array(i) ! Added format specification
        data = trim(data) // trim(adjustl(num_str))
        if (i /= size(array)) then
            data = trim(data) // ","
        end if
    end do

    ! Get the IP address from the command line
    call get_command(ip_address)

    ! Construct the complete URL using the IP address
    url = 'http://' // trim(ip_address) // ':8080/data'
    
    write(*, '(*(a))') 'Sending array to: ', url

    headers = [pair_type('Content-Type', 'text/plain')]

    ! Send a POST request to the Python server with the array data
    response = request(url, method=HTTP_POST, data=data, header=headers)

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

end program simple_post
